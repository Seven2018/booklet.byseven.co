
<template>
  <div class="flex-column-centered font-weight-500 bkt-dark-grey">
    <h1 class="fs-2_4rem  my-5">Filter by tags</h1>
    <p class=" mb-3" style="line-height: 3em">
      Tags are use to filter your index.<br>
      You can create, modify and delete tags to classify your items.<br>
      Each tags can be contained in a category, click on<br>
    </p>
    <div class="flex-row-center-centered mb-5">
      <bkt-button iconify="ant-design:plus-circle-outlined">Create category</bkt-button>
      <p class="ml-3">to create one.</p>
    </div>
    <div class="flex-row-center-centered align-items-center" style="margin-bottom: 100px">
      <p>
        Click on
      </p>
      <bkt-options-icon class="mx-4" :horizontal="true"></bkt-options-icon>
      <p>
        on an item to manage its tags.
      </p>
    </div>
  </div>
</template>

<script>
import BktButton from "../BktButton";
import BktOptionsIcon from "../BktOptionsIcon";
export default {
  components: {BktOptionsIcon, BktButton}
}
</script>