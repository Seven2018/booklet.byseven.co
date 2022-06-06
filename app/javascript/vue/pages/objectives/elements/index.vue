
<template>
  <bkt-index-skeleton>
    <template v-slot:title>Targets</template>
    <template v-slot:body>
      <target-index-search></target-index-search>
      <target-index-table></target-index-table>
    </template>
  </bkt-index-skeleton>
</template>

<script>
import BktIndexSkeleton from "../../../components/BktIndexSkeleton";
import TargetIndexSearch from "./TargetIndexSearch";
import TargetIndexTable from './TagetIndexTable'

export default {
  components: {BktIndexSkeleton, TargetIndexSearch, TargetIndexTable}
}
</script>