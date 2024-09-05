#!/usr/bin/env node

// Purposes:
// Generate an index.js file importing and registering Web Components

import fs from 'node:fs'
import path from 'node:path'
import process from 'node:process'

const logLevels = {
  OFF: 0,
  INFO: 1,
  DEBUG: 2
}

const logLevel = logLevels.INFO
const scriptPath = process.argv[1]
const scriptDir = path.dirname(scriptPath)
const rootDir = path.dirname(scriptDir)
const packageRoot = path.join(rootDir, 'app/javascript/web-components')

function log(message, level = logLevels.INFO) {
  if (level > logLevel) return

  console.log(message)
}

function debug(message) {
  log(message, logLevels.DEBUG)
}

const walk = function (dir, shouldRejectFile) {
  let results = []
  if (!fs.existsSync(dir)) {
    return results
  }

  debug(`Analyzing ${dir}`)

  const list = fs.readdirSync(dir)
  list.forEach(file => {

    file = `${dir}/${file}`
    const stat = fs.statSync(file)
    if (stat && stat.isDirectory()) {
      results = results.concat(walk(file, shouldRejectFile))
    } else if (shouldRejectFile && shouldRejectFile(file)) {
      debug(`  skipping ${file}`)
    } else {
      results.push(file)
    }
  })

  if (results.length > 0) {
    debug(`  exported ${results.length} files from ${dir}`)
  }
  return results
}

// Comparison tests

const isDotFile = file => path.basename(file).startsWith('.')

const isJSFile = file => ['.js', '.jsx'].includes(path.extname(file))

const isComponentFile = file => (/component.js$/).test(file)

const isBaseComponentFile = file => (/lcad-element.component.js$/).test(file)
const isControlComponentFile = file => (/\/vrt-control.component.js$/).test(file)

const isIndexFile = file => (/index.js$/).test(file)

/**
 * @return boolean - true if file should be omitted, false if file should be included
 */
const shouldExcludeFile = file => (
  isDotFile(file)
  || isIndexFile(file)
  || !isJSFile(file)
  || !isComponentFile(file)
  || isBaseComponentFile(file)
  || isControlComponentFile(file)
)

const exportGroup = library => {
  const files = walk(`${library}`, shouldExcludeFile)
  const stripExtension = file => file.slice(0, -path.extname(file).length)
  const stripDirectory = file => file.slice(library.length + 1)
  const prepFile = file => stripDirectory(stripExtension(file))
  const symbolForFile = file => path.basename(file)
  const makeExport = file => ({
    symbol: symbolForFile(file),
    file
  })

  const bySymbol = (a, b) => {
    const aSymbol = a.symbol
    const bSymbol = b.symbol

    // put anything that does not have a symbol first
    if (!aSymbol) return -1
    if (!bSymbol) return 1

    if (aSymbol < bSymbol) return -1
    if (aSymbol > bSymbol) return 1
    return 0
  }

  return files.map(prepFile).map(makeExport).sort(bySymbol)
}

const comments = [
  'THIS IS AN AUTO-GENERATED FILE. DO NOT EDIT IT MANUALLY.',
  'To update this index file, run "yarn web_components:index"\n'
].map(line => `// ${line}`).join("\n")

const writeIndexFile = (exportsString, file) => {
  const fullPath = path.join(process.cwd(), file)
  log(`\tWriting file ${fullPath}`)
  const fd = fs.openSync(file, 'w')
  try {
    fs.writeSync(fd, comments)
    fs.writeSync(fd, '\n/* eslint-disable import/order */\n\n')
    fs.writeSync(fd, exportsString)
    fs.writeSync(fd, '\n')
  } finally {
    if (fd !== undefined) fs.closeSync(fd)
  }
}

const camelize = s => s.replace(/-./g, x => x[1].toUpperCase())
const capitalizeFirstLetter = string => string.charAt(0).toUpperCase() + string.slice(1)

const getImportNameFrom = symbol => {
  const filename = symbol.split('.')[0]
  const [componentPrefix, ...componentNameParts] = filename.split('-')
  const componentName = capitalizeFirstLetter(camelize(componentNameParts.join('-')))

  return [filename, `${componentPrefix.toUpperCase()}${componentName}`]
}

const importString = exportsList => {
  const importLine = ({ symbol, file }) => {
    const [_filename, importStatement] = getImportNameFrom(symbol)

    return `import ${importStatement} from './${file}.js'`
  }

  return `${exportsList.map(importLine).join('\n')}\n`
}

const exportSymbolString = exportsList => {
  const exportLine = ({ symbol, _file }) => {
    if (!symbol) return

    const [filename, importStatement] = getImportNameFrom(symbol)

    return `customElements.define('${filename}', ${importStatement})`
  }
  return exportsList.map(exportLine).filter(Boolean).join('\n')
}

function cd(packageName) {
  const packagePath = path.join(packageRoot, packageName)
  process.chdir(packagePath)
  log(`\tChanged directory to ${process.cwd()}`)
}

// #1: generate index.js files for each package/library
const libraryIndexLabel = '[1]'
console.log(`${libraryIndexLabel}: Generating Package/Library Indexes`)
console.time(libraryIndexLabel)

cd('.')

const exportsList = exportGroup(".")
const string = [importString(exportsList), exportSymbolString(exportsList)].join('\n')
writeIndexFile(string, `./index.js`)

console.timeEnd(libraryIndexLabel)
