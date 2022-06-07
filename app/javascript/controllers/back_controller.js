import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  back () {
    let from = null

    if (this.element.dataset.forceFallback || document.referrer == undefined)  {
      console.log(this.element.dataset.forceFallback)
      from = this.element.dataset.fallback
    } else {
      from = document.referrer
    }

    const params = new Proxy(new URLSearchParams(window.location.search), {
      get: (searchParams, prop) => searchParams.get(prop),
    });

    if (params.back_search_text) {
      from += `?back_search_text=${params.back_search_text}`
    }

    document.location.href = from
  }
}
