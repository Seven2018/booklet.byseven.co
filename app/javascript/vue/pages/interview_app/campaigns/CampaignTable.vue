<template>
  <index-table
      v-if="genericFetchEntity.data"
      :headers="headers"
      :table-data="genericFetchEntity.data['campaigns']"
      :pagination="genericFetchEntity.pagination"
      @fetch-page="fetchPage"
      @row-click="goto('', $event.id)"
  >
    <template v-slot="{id, title, campaign_type, categories, employees_count, completion}">
      <td>
        <bkt-table-first-column>
          {{ title }}
        </bkt-table-first-column>
      </td>

      <td>
        <div class="d-flex align-items-center">
          <div class="mr-3 rounded-5px p-3 bkt-bg-light-blue bkt-blue">
            <span class="iconify" data-width="15" data-height="15" :data-icon="campaign_icon(campaign_type)"></span>
          </div>
          <p>{{ campaign_type_str(campaign_type) }}</p>
        </div>
      </td>

      <td>
        <display-tag-in-index :tags="categories"></display-tag-in-index>
      </td>

      <td>
        <p>
          {{ employees_count }}
        </p>
      </td>

      <td>
        <div class="completion " :class="getClassByCompletion(completion)">
          <p>{{ completion }}%</p>
        </div>
      </td>

      <td>
        <div class="d-flex align-items-center">
          <bkt-dots-button>
            <button
                class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover width-100 pl-3 pr-3 p-3"
                @click.stop="openEditCampaignTags(id)"
            >
              Edit campaign tags
            </button>
            <button
                v-if="completion != 100"
                class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover width-100 pl-3 pr-3 p-3"
                @click.stop="sendRemainder(id)"
            >
              Send email
            </button>
            <button
                class="flex-row-start-centered fs-1_4rem bkt-red bkt-bg-light-grey10-hover width-100 pl-3 pr-3 p-3"
                @click.stop="deleteCampaign(id)"
            >
              Delete
            </button>
          </bkt-dots-button>
        </div>
      </td>
    </template>
  </index-table>
</template>

<script>
import tools from "../../../mixins/tools";
import store from "../../../store";
import IndexTable from "../../../components/IndexTable";
import BktTableFirstColumn from "../../../components/BktTableFirstColumn";
import DisplayTagInIndex from "../../../components/DisplayTagInIndex";
import BktDotsButton from "../../../components/BktDotsButton";
import axios from "../../../plugins/axios";
import routes from "../../../constants/routes";

export default {
  mixins: [tools],
  data() {
    return {
      headers: ['Campaign title', 'Campaign type', 'Tags', 'Employees', 'Completion', ''],
      genericFetchEntity: store.state.genericFetchEntity
    }
  },
  created() {
    store.dispatch('genericFetchEntity/fetch',
        {
          pathKey: 'campaigns_list'
        }
    )
  },
  methods: {
    fetchPage(page) {
      store.dispatch('genericFetchEntity/fetch', {
        pathKey: 'campaigns_list',
        params: {
          'page[number]': page,
        }
      })
    },
    getClassByCompletion(completion) {
      if (completion == 0) {
        return 'bkt-bg-light-grey'
      } else if (completion == 100) {
        return 'bkt-bg-green'
      } else {
        return 'bkt-bg-yellow'
      }
    },
    async sendRemainder(id) {
      try {
        await axios.get(this.$routes.generate('send_notification_email', {id}))

        this.$modal.open({
          type: 'action_done',
          title: `Reminder is on its way !`,
          description: 'The employee will receive an email in a few moments.',
          textConfirm: 'Great !',
          confirm() {
            this.$modal.close()
          }
        })
      } catch (e) {
        console.log('error', e)
      }
    },
    async deleteCampaign(id) {
      this.$modal.open({
        type: 'delete',
        title: `Are you sure you want to delete this campaign ?<br/>(This is a permanent action)`,
        textClose: 'No',
        textConfirm: 'Yes, delete',
        textLoading: 'Deleting ...',
        async confirm() {
          await axios.delete(routes.generate('campaigns_id', {id: id}) + '.json')
          await store.dispatch('genericFetchEntity/fetch',
              {
                pathKey: 'campaigns_list'
              }
          )
          this.$modal.close()
        }
      })
    },
    async openEditCampaignTags(id) {
      this.$modal.open({
        type: 'edit-campaign-tags',
        campaignId: id,
      })
    }
  },
  components: {DisplayTagInIndex, BktTableFirstColumn, IndexTable, BktDotsButton}
}
</script>

<style scoped>
.completion {
  width: 7rem;
  padding: 1rem 1.5rem;
  border-radius: .5rem;
  font-weight: 600;
  color: white;
  text-align: center;
}
</style>
