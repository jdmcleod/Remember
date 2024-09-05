import { LitElement, css, html } from "lit"

export default class REMUploader extends LitElement {
  static properties = {
    allowedFileExtensions: { type: Array, attribute: true, reflect: true },
    invalidFileExtensions: { type: Array, state: true },
    dataTransfer: { type: Object, state: true },
    fileNames: { type: Array, state: true },
  }

  constructor() {
    super()

    this.allowedFileExtensions = undefined
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
    const fileExtension = file.name.split('.')[1]
    if (Boolean(this.allowedFileExtensions) && !this.allowedFileExtensions.includes(fileExtension)){
      return this.invalidFileExtensions.push(fileExtension)
    }
    this.dataTransfer.items.add(file)
    this.fileNames.push(fullPath ?? file.name)
    this._fileInput().files = this.dataTransfer.files
    this.requestUpdate()
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
        <ph-icon name="plus" size="x-large" class="upload-container__add-icon"></ph-icon>
        <div>Click to choose or drag and drop and image</div>
        <div>(${this.allowedFileExtensions.map(fileExtension => `.${fileExtension}`).join(', ')})</div>
        <slot name="input" class="files-input"></slot>
      </div>
      <slot name="errors" class="files-errors"></slot>
    `
  }

  static styles = css`
    .files-container {
      display: flex;
      flex-direction: column;
      max-height: 240px;
      overflow-y: auto;

      .file-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        transition: 0.2s;
        padding: var(--op-space-2x-small) var(--op-space-x-small);

        .file-delete {
          visibility: hidden;

          .file-delete__icon {
            color: var(--op-color-alerts-danger-base);
          }
        }

        &:hover {
          background-color: var(--op-color-neutral-plus-eight);
          border-radius: var(--op-radius-medium);;

          .file-delete {
            visibility: visible;
          }
        }
      }
    }

    .upload-container {
      width: 100%;
      height: var(--op-space-5x-large);
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      cursor: pointer;
      margin-block: var(--op-space-x-small);
      padding-block: var(--op-space-small);

      background-color: var(--op-color-primary-plus-eight);
      color: var(--op-color-primary-on-plus-eight-alt);
      border-radius: var(--op-radius-medium);
      border: 1px dashed var(--op-color-primary-plus-six);

      .upload-container__add-icon {
        color: var(--op-color-neutral-plus-three);
        margin-bottom: var(--op-space-x-small);
      }

      .files-input {
        display: none;
      }

      &.upload-container--dragover, &:hover {
        background-color: var(--op-color-primary-plus-seven);
        border: 1px dashed var(--op-color-primary-plus-five);
      }
    }

    .upload-container * {
      pointer-events: none;
    }

    .files-label {
      color: var(--op-color-on-background);
      font-size: var(--op-font-x-small);
    }

    .files-errors {
      color: var(--op-color-alerts-danger-base);
      font-size: var(--op-font-x-small);
    }

    .upload-error {
      color: var(--op-color-alerts-danger-base)
    }
  `
}
