
<template>
  <bkt-index-skeleton>
    <template v-slot:title>Target templates</template>
    <template v-slot:create-index>
      <bkt-button
          type="blue"
          iconify="ant-design:plus-circle-outlined"
          :href="$routes.generate('objective_templates_new')"
      >New template</bkt-button>
    </template>
    <template v-slot:body>
      <employees-index-search path-key="objective_templates_list"></employees-index-search>
      <target-template-table></target-template-table>
    </template>
  </bkt-index-skeleton>
</template>

<script>
import BktIndexSkeleton from "../../../components/BktIndexSkeleton";
import BktButton from "../../../components/BktButton";
import TargetTemplateTable from "./TargetTemplateTable";
import EmployeesIndexSearch from "../users/EmployeesIndexSearch";

export default {
  components: {
    EmployeesIndexSearch,
    TargetTemplateTable,
    BktButton,
    BktIndexSkeleton,
  }
}
</script>