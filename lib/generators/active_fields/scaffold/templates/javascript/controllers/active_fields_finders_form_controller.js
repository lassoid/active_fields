import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "inputTemplatesContainer",
    "inputTemplate",
    "inputsContainer",
    "input",
  ]

  connect() {
    this.inputTemplatesContainerTarget.style.display = "none"
  }

  addInput(e) {
    e.preventDefault()

    const selectedOption = e.target.options[e.target.selectedIndex]
    const selectedName = selectedOption.dataset.activeFieldName
    const selectedType = selectedOption.value

    if (!selectedName || !selectedType) { return }

    const templateInput = this.inputTemplateTargets.find((templateInput) => {
      return templateInput.dataset.activeFieldName === selectedName && templateInput.dataset.type === selectedType
    })

    let newInput = templateInput.cloneNode(true)
    newInput.dataset.activeFieldsFindersFormTarget = "input"
    this.#setInputIndex(newInput)

    this.inputsContainerTarget.append(newInput)

    e.target.value = ""
  }

  removeInput(e) {
    e.preventDefault()

    e.target.parentElement.remove()
  }

  #getLastIndex() {
    if (this.inputTargets.length === 0) { return -1 }

    return Math.max(...this.inputTargets.map((input) => +input.dataset.index))
  }

  #setInputIndex(input) {
    const newIndex = this.#getLastIndex() + 1

    input.dataset.index = newIndex.toString()
    Array.from(input.children).forEach((element) => {
      if (element.hasAttribute("name") && element.name.includes("[0]")) {
        element.name = element.name.replace("[0]", `[${newIndex}]`)
      }
    })
  }
}
