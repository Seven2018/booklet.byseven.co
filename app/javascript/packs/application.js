import "bootstrap";
import Sortable from 'sortablejs';
require("../plugins/flatpickr")

// Add Choices Dropdown
// const Choices = require('choices.js')
// document.addEventListener("turbolinks:load", function() {
//     var dropDownSelects = new Choices('#dropdown-choice-select')
// })

try {
  require("trix")
  require("@rails/actiontext")
}
catch(err) {
}


// window.onload = function(){
//   var el = document.getElementById('workshop-card-list');
//   var sortable = Sortable.create(el, {animation: 250});
// };

