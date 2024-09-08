import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["templateFieldGroup"]

  connect() {
    this.templateFieldGroupTarget.style.display = "none"
  }

  addField(e) {
    e.preventDefault()

    let newFieldGroup = this.templateFieldGroupTarget.cloneNode(true)
    delete newFieldGroup.dataset.arrayFieldTarget
    newFieldGroup.style.removeProperty("display")

    e.target.before(newFieldGroup)
  }

  removeField(e) {
    e.preventDefault()

    e.target.parentElement.remove()
  }
}
