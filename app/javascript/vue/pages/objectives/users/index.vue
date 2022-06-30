<template>
  <bkt-index-skeleton>
    <template v-slot:title>Employees targets</template>
    <template v-slot:body>
      <generic-index-search path-key="objective_list"></generic-index-search>
      <employees-index-table v-show="genericFetchEntity.data && genericFetchEntity.data['users'] && genericFetchEntity.data['users'].length > 0"></employees-index-table>
      <bkt-create-entity-from-index
          v-show="genericFetchEntity.data && genericFetchEntity.data['users'] && genericFetchEntity.data['users'].length === 0 && !genericFetchEntity.search"
          type="roadmap"
          :href="$routes.generate('objective_new')"
      >
        target employee
      </bkt-create-entity-from-index>
      <bkt-no-entity-from-index
          v-show="genericFetchEntity.data && genericFetchEntity.data['users'] && genericFetchEntity.data['users'].length === 0 && genericFetchEntity.search"
      ></bkt-no-entity-from-index>
      <bkt-box-loader v-show="!genericFetchEntity.data" type="roadmap"></bkt-box-loader>
    </template>
  </bkt-index-skeleton>
</template>

<script>
import BktIndexSkeleton from "../../../components/BktIndexSkeleton";
import GenericIndexSearch from "./GenericIndexSearch";
import EmployeesIndexTable from "./EmployeesIndexTable";
import BktCreateEntityFromIndex from "../../../components/BktCreateEntityFromIndex";
import store from "../../../store";
import BktNoEntityFromIndex from "../../../components/BktNoEntityFromIndex";
import BktBoxLoader from "../../../components/BktBoxLoader";

export default {
  data() {
    return {
      genericFetchEntity: store.state.genericFetchEntity
    }
  },
  components: {
    BktBoxLoader,
    BktNoEntityFromIndex,
    BktCreateEntityFromIndex,
    EmployeesIndexTable,
    BktIndexSkeleton,
    GenericIndexSearch,
  }
}
</script>
