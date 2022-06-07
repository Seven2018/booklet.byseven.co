
<template>
  <bkt-index-skeleton>
    <template v-slot:title>Targets</template>
    <template v-slot:body>
      <target-index-search></target-index-search>
      <target-index-table v-show="genericFetchEntity.data && genericFetchEntity.data['objective/elements'] && genericFetchEntity.data['objective/elements'].length > 0"></target-index-table>
      <bkt-create-entity-from-index
          v-show="genericFetchEntity.data && genericFetchEntity.data['objective/elements'] && genericFetchEntity.data['objective/elements'].length === 0 && !genericFetchEntity.search"
          type="roadmap"
          :href="$routes.generate('objective_new')"
      ></bkt-create-entity-from-index>
      <bkt-no-entity-from-index
          v-show="genericFetchEntity.data && genericFetchEntity.data['objective/elements'] && genericFetchEntity.data['objective/elements'].length === 0 && genericFetchEntity.search"
      ></bkt-no-entity-from-index>
      <bkt-box-loader v-show="!genericFetchEntity.data" type="roadmap"></bkt-box-loader>
    </template>
  </bkt-index-skeleton>
</template>

<script>
import BktIndexSkeleton from "../../../components/BktIndexSkeleton";
import TargetIndexSearch from "./TargetIndexSearch";
import TargetIndexTable from './TagetIndexTable'
import BktBoxLoader from "../../../components/BktBoxLoader";
import store from "../../../store";
import BktCreateEntityFromIndex from "../../../components/BktCreateEntityFromIndex";
import BktNoEntityFromIndex from "../../../components/BktNoEntityFromIndex";

export default {
  data() {
    return {
      genericFetchEntity: store.state.genericFetchEntity
    }
  },
  components: {
    BktNoEntityFromIndex,
    BktCreateEntityFromIndex, BktBoxLoader, BktIndexSkeleton, TargetIndexSearch, TargetIndexTable}
}
</script>