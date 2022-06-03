<template>
  <bkt-index-skeleton>
    <template v-slot:title>Employees objectives</template>
    <template v-slot:body>
      <employees-index-search path-key="objective_list"></employees-index-search>

      <employees-index-table></employees-index-table>
    </template>
  </bkt-index-skeleton>
</template>

<script>
import BktIndexSkeleton from "../../../components/BktIndexSkeleton";
import EmployeesIndexSearch from "./EmployeesIndexSearch";
import EmployeesIndexTable from "./EmployeesIndexTable";

export default {
  components: {
    EmployeesIndexTable,
    BktIndexSkeleton,
    EmployeesIndexSearch,
  }
}
</script>
