<template>
  <bkt-index-skeleton>
    <template v-slot:title>Employees objectives</template>
    <template v-slot:body>
      <generic-index-search path-key="objective_list"></generic-index-search>

      <employees-index-table></employees-index-table>
    </template>
  </bkt-index-skeleton>
</template>

<script>
import BktIndexSkeleton from "../../../components/BktIndexSkeleton";
import GenericIndexSearch from "./GenericIndexSearch";
import EmployeesIndexTable from "./EmployeesIndexTable";

export default {
  components: {
    EmployeesIndexTable,
    BktIndexSkeleton,
    GenericIndexSearch,
  }
}
</script>
