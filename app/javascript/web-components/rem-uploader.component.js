import { LitElement, css, html } from "lit"

export default class REMUploader extends LitElement {
  static properties = {
    allowedFileExtensions: { type: Array, attribute: true, reflect: true },
    formId: { type: String },
    invalidFileExtensions: { type: Array, state: true },
    dataTransfer: { type: Object, state: true },
    fileNames: { type: Array, state: true },
  }

  constructor() {
    super()

    this.allowedFileExtensions = undefined
    this.formId = undefined
    this.invalidFileExtensions = []
    this.dataTransfer = new DataTransfer()
    this.fileNames = []
  }

  connectedCallback() {
    super.connectedCallback();
    this._fileInput().addEventListener('input', this._onUpload.bind(this))
  }

  _fileInput() { return this.querySelector('input[type="file"]') }

  _onUpload(event) {
    this.invalidFileExtensions = []
    const files = [...event.target.files]
    files.forEach(file => this._addFile(file))
  }

  _onClick(_event) {
    this._fileInput().click()
  }

  _onDragover(event) {
    event.preventDefault()

    event.target.classList.add('upload-container--dragover')
  }

  _onDragleave(event) {
    event.preventDefault()

    event.target.classList.remove('upload-container--dragover')
  }

  _onDrop(event) {
    event.preventDefault()

    this.invalidFileExtensions = []
    event.target.classList.remove('upload-container--dragover')
    const dataTransferItems = [...event.dataTransfer.items]
    dataTransferItems.forEach(item => this._addEntryToFiles(item.webkitGetAsEntry()))
  }

  _addEntryToFiles(entry) {
    if (entry?.isFile) {
      entry.file(file => this._addFile(file, entry.fullPath.substring(1)))
    } else if (entry?.isDirectory) {
      const dirReader = entry.createReader()
      dirReader.readEntries(entries => {
        entries.forEach(entry => this._addEntryToFiles(entry))
      })
    }
  }

  _addFile(file, fullPath = undefined) {
    const fileNameSplit = file.name.split('.')
    const fileExtension = fileNameSplit[fileNameSplit.length - 1]
    if (!this._fileExtensionIsValid(fileExtension)) return this.invalidFileExtensions.push(fileExtension)

    this.dataTransfer.items.add(file)
    this.fileNames.push(fullPath ?? file.name)
    this._fileInput().files = this.dataTransfer.files

    if (!!this.formId) document.getElementById(this.formId).requestSubmit()

    this.requestUpdate()
  }

  _fileExtensionIsValid(fileExtension) {
    if (!this.allowedFileExtensions) return true

    const allowedFileExtensions = this.allowedFileExtensions.map(allowedFileExtension => allowedFileExtension.toLowerCase())
    return allowedFileExtensions.includes(fileExtension.toLowerCase())
  }

  _renderUploadError() {
    if (this.invalidFileExtensions.length === 0) return

    return html`
      <div class="upload-error">Invalid file types rejected: '${this.invalidFileExtensions.join("', '")}'</div>
    `
  }

  render() {
    return html`
      ${this._renderUploadError()}
      <div class="upload-container" @click=${this._onClick} @drop=${this._onDrop} @dragover=${this._onDragover} @dragleave=${this._onDragleave}>
        <ti-icon name="camera" size="supa-large" class="upload-container__add-icon"></ti-icon>
      </div>
      <slot name="errors" class="files-errors"></slot>
    `
  }

  static styles = css`
    :host {
      height: 100%;
      display: flex;
      flex-direction: column;
    }
      
    .upload-container {
      width: 215px;
      flex-grow: 1;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      cursor: pointer;
      gap: var(--op-space-x-small);

      background-color: var(--op-color-primary-plus-eight);
      color: var(--op-color-primary-plus-six);
      border-radius: var(--op-radius-medium);
      border: 3px dashed var(--op-color-primary-plus-six);
      box-sizing: border-box;
      font-size: var(--op-font-small);
      text-align: center;

      .upload-container__add-icon {
        margin-bottom: var(--op-space-2x-small);
      }

      .files-input {
        display: none;
      }

      &.upload-container--dragover, &:hover {
        background-color: var(--op-color-primary-plus-seven);
        border: 3px dashed var(--op-color-primary-plus-five);
      }
    }

    .upload-container * {
      pointer-events: none;
    }

    .files-errors {
      color: var(--op-color-alerts-danger-base);
      font-size: var(--op-font-small);
    }

    .upload-error {
      color: var(--op-color-alerts-danger-base);
      font-size: var(--op-font-small);
      margin: var(--op-space-2x-small);
      margin-top: 0;
    }
      
    .allowed-file-extensions {
      color: var(--op-color-primary-on-plus-eight-alt);
      font-size: var(--op-font-x-small);
    }
  `
}
