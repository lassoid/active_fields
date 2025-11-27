import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "scopeInput",
    "disableScopeInput",
  ]

  toggleScopeInput(e) {
    e.preventDefault()

    if (this.disableScopeInputTarget.checked) { 
      this.scopeInputTarget.disabled = true
      this.scopeInputTarget.value = ""
    } else {
      this.scopeInputTarget.disabled = false
    }
  }
}
