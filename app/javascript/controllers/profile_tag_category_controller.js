import {Controller} from "@hotwired/stimulus";
import autoComplete from "@tarekraafat/autocomplete.js";
import {auto} from "@popperjs/core";

export default class extends Controller {
  static get targets() {
    return ['tagCategories']
  }

  connect() {
    this.tagCategoriesInputs = {}
    this.tagCategoriesTargets.forEach(tagCategory => {
      const autoCompleteJS = new autoComplete({
        selector: tagCategory.dataset.selector,
        placeHolder: "Search ...",
        data: {
          src: JSON.parse(tagCategory.dataset.tagsAvailable),
          keys: ['tag_name'],
          cache: true,
        },
        trigger: (_) => {
          return true
        },
        resultsList: {
          class: 'border-bkt-light-grey pt-2 auto-complete-js-list',
          element: (list, data) => {
            if (!data.results.length) {
              const message = document.createElement("div");
              message.setAttribute("class", "bkt-bg-light-grey8-hover font-weight-500 p-4 d-flex");
              message.setAttribute('data-action', 'click->profile-tag-category#createTag')
              message.setAttribute('data-query', data.query)
              message.setAttribute('data-tag-category-id', tagCategory.dataset.tagCategoryId)
              message.innerHTML = `<span class="fs-3rem mr-2" data-query="${data.query}" data-tag-category-id="${tagCategory.dataset.tagCategoryId}">+</span>
                                   <span data-query="${data.query}" class="d-flex align-items-center" data-tag-category-id="${tagCategory.dataset.tagCategoryId}">Create '${data.query}'</span>`;

              list.prepend(message);
            }
          },
          noResults: true,
        },
        resultItem: {
          highlight: {
            render: true
          }
        },
        events: {
          input: {
            focus: () => {
              autoCompleteJS.start()
            }
          },
        },
      });

      autoCompleteJS.input.addEventListener("selection", (event) => {
        const feedback = event.detail;
        const tagCategoryId = event.target.dataset.tagCategoryId
        const tagId = feedback.selection.value['id']
        const tagName = feedback.selection.value[feedback.selection.key];
        autoCompleteJS.input.blur();

        this.addTagCategory(this.element.dataset.addTagCategoryTagsPath, tagCategoryId, tagId, null, () => {
          autoCompleteJS.input.value = tagName
        })
      });

      this.tagCategoriesInputs[tagCategory.dataset.tagCategoryId] = autoCompleteJS
    })
  }

  addTagCategory(path, tag_category_id, tag_id, tag_name, callback) {
    if (path) {
      fetch(path, {
        method: "POST",
        headers: {
          "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
          "Content-Type": "application/json"
        },
        body: JSON.stringify({tag_category_id, tag_id, tag_name})
      })
        .then(callback)
    } else callback()
  }

  createTag(event) {
    this.addTagCategory(
      this.element.dataset.createTagCategoryTagsPath,
      event.target.dataset.tagCategoryId,
      null,
      event.target.dataset.query,
      () => {
        if (this.tagCategoriesInputs[event.target.dataset.tagCategoryId]) {
          const autoComplete = this.tagCategoriesInputs[event.target.dataset.tagCategoryId]

          autoComplete.input.blur()
          autoComplete.input.value = event.target.dataset.query
        }
      }
    )
  }
}