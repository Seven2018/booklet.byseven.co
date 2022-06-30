
<template>
  <div :class="getBgByCampaignStatus(status)" class="bkt-white rounded-20px py-1 px-3">
    <p>
      {{status.split('_').join(' ') | capitalize}}
    </p>
  </div>
</template>
<script>
import tools from "../../mixins/tools";

export default {
  mixins: [tools],
  props: ['status'],
}
</script>