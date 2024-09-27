import { LitElement, css, html } from "lit"

export default class REMUploader extends LitElement {
  static properties = {
    allowedFileExtensions: { type: Array, attribute: true, reflect: true },
    variant: { type: String },
    formId: { type: String },
    invalidFileExtensions: { type: Array, state: true },
    dataTransfer: { type: Object, state: true },
    fileNames: { type: Array, state: true },
  }

  constructor() {
    super()

    this.allowedFileExtensions = undefined
    this.variant = 'full'
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

  _renderUploadContainer() {
    return html`
      <div class="upload-container" @click=${this._onClick} @drop=${this._onDrop} @dragover=${this._onDragover} @dragleave=${this._onDragleave}>
        <ti-icon name="camera" class="upload-container__add-icon"></ti-icon>
      </div>
    `
  }

  render() {
    return html`
      ${this._renderUploadError()}
      ${this._renderUploadContainer()}
      <slot name="errors" class="files-errors"></slot>
    `
  }

  static styles = css`
    :host {
      height: 100%;
      display: flex;
      flex-direction: column;
    }

    :host([variant='floating']) {
      .upload-container {
        position: absolute;
        bottom: var(--op-space-small);
        right: var(--op-space-small);
        display: flex;
        align-items: center;
        justify-content: center;
        width: 3rem;
        height: 3rem;
        border: none;
        background-color: var(--op-color-primary-base);
        border-radius: var(--op-radius-2x-large);
        color: var(--op-color-neutral-plus-max);

        ti-icon {
          --font-size: var(--op-font-large);
        }

        &.upload-container--dragover, &:hover {
          background-color: var(--op-color-primary-minus-one);
          color: var(--op-color-primary-on-minus-one);
        }
      }
    }

    @media only screen and (min-width: 712px) {
      .upload-container {
        width: 215px;
        flex-grow: 1;
        display: flex;
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

        ti-icon {
          --font-size: 10rem;
        }

        .files-input {
          display: none;
        }

        &.upload-container--dragover, &:hover {
          background-color: var(--op-color-primary-plus-seven);
          border: 3px dashed var(--op-color-primary-plus-five);
        }
      }
    }

    @media only screen and (max-width: 712px) {
      .upload-container {
        position: absolute;
        bottom: 2rem;
        right: 2rem;
        display: flex;
        align-items: center;
        justify-content: center;
        width: 3rem;
        height: 3rem;
        border: none;
        background-color: var(--op-color-primary-base);
        border-radius: var(--op-radius-2x-large);
        color: var(--op-color-neutral-plus-max);
          
        ti-icon {
          --font-size: var(--op-font-large);
        }
      }
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
