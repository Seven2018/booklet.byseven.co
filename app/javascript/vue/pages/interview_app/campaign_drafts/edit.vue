
<template>
  <div>
    <bkt-cancel-button @click="openPopUp"></bkt-cancel-button>
  </div>
</template>
<script>
import BktCancelButton from "../../../components/BktCancelButton";
import axios from "../../../plugins/axios";

export default {
  props: ['campaignDraftId'],
  methods: {
    openPopUp() {
      const campaignDraftId = this.campaignDraftId

      this.$modal.open({
        type: 'delete',
        title: `Are you sure you want to delete this campaign draft ?<br> (This is a permanent action)`,
        textClose: 'No, keep it for later',
        textConfirm: 'Yes, delete',
        textLoading: 'Deleting ...',
        close() {
          window.location.href = this.$routes.generate('campaigns')
        },
        async confirm() {
          try {
            await axios.delete(this.$routes.generate('campaign_drafts_id', {id: campaignDraftId}))
            this.$modal.close()
            window.location.href = this.$routes.generate('campaigns')
          } catch (e) {
            console.log(e)
          }
        }
      })
    }
  },
  components: {BktCancelButton}
}
</script>