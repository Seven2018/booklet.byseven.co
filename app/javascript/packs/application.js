import "bootstrap";
import "floating-scroll";

require("../plugins/flatpickr")
require("../plugins/floatingscroll")


try {
  require("trix")
  require("@rails/actiontext")
}
catch(err) {
}

import { toggleShowBranchTree } from '../components/tree';

toggleShowBranchTree();

import 'controllers'
