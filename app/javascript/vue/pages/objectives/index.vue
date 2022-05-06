<template>
  <div class="width-80 mt-5 mx-auto">
    <div class="flex-row-between-centered mb-5">
      <div class="flex-column">
        <h1 class="font-weight-700 fs-2_4rem">Employees objectives</h1>
      </div>
      <div class="flex-column">
        <bkt-button type="blue" iconify="ant-design:plus-circle-outlined">
          New objective
        </bkt-button>
      </div>
    </div>
    <bkt-box>
      <div class="flex-row-start-centered">
        <bkt-search></bkt-search>
        <p class="ml-5 font-weight-500">
          Reset
        </p>
      </div>
    </bkt-box>
  </div>
</template>

<script>
import BktButton from '../../components/BktButton';
import BktBox from "../../components/BktBox";
import BktSearch from "../../components/bktSearch";

export default {
  components: {
    BktSearch,
    BktBox,
    BktButton,
  }
}
</script>