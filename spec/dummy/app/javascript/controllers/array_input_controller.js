import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["templateInputGroup"]
  static classes = ["templateInputGroup"]

  connect() {
    this.templateInputGroupTarget.classList.add(...this.templateInputGroupClasses)
  }

  addField(e) {
    e.preventDefault()

    let newInput = this.templateInputGroupTarget.cloneNode(true)
    delete newInput.dataset.arrayInputTarget
    newInput.classList.remove(...this.templateInputGroupClasses)

    e.target.before(newInput)
  }

  removeField(e) {
    e.preventDefault()

    e.target.parentElement.remove()
  }
}
