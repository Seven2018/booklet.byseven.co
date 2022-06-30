
<template>
  <bkt-index-skeleton>
    <template v-slot:title>Target templates</template>
    <template v-slot:create-index>
      <bkt-button
          type="roadmap"
          iconify="ant-design:plus-circle-outlined"
          :href="$routes.generate('objective_templates_new')"
      >New template</bkt-button>
    </template>
    <template v-slot:body>
      <generic-index-search path-key="objective_templates_list"></generic-index-search>
      <target-template-table v-show="genericFetchEntity.data && genericFetchEntity.data['objective/templates'] && genericFetchEntity.data['objective/templates'].length > 0"></target-template-table>
      <bkt-create-entity-from-index
          v-show="genericFetchEntity.data && genericFetchEntity.data['objective/templates'] && genericFetchEntity.data['objective/templates'].length === 0 && !genericFetchEntity.search"
          type="roadmap"
          :href="$routes.generate('objective_new')"
      >
        target employee
      </bkt-create-entity-from-index>
      <bkt-no-entity-from-index
          v-show="genericFetchEntity.data && genericFetchEntity.data['objective/templates'] && genericFetchEntity.data['objective/templates'].length === 0 && genericFetchEntity.search"
      ></bkt-no-entity-from-index>
      <bkt-box-loader v-show="!genericFetchEntity.data" type="roadmap"></bkt-box-loader>
    </template>
  </bkt-index-skeleton>
</template>

<script>
import BktIndexSkeleton from "../../../components/BktIndexSkeleton";
import BktButton from "../../../components/BktButton";
import TargetTemplateTable from "./TargetTemplateTable";
import GenericIndexSearch from "../users/GenericIndexSearch";
import BktCreateEntityFromIndex from "../../../components/BktCreateEntityFromIndex";
import BktNoEntityFromIndex from "../../../components/BktNoEntityFromIndex";
import BktBoxLoader from "../../../components/BktBoxLoader";
import store from "../../../store";

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
    GenericIndexSearch,
    TargetTemplateTable,
    BktButton,
    BktIndexSkeleton,
  }
}
</script>