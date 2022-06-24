<template>
  <index-table
      v-if="genericFetchEntity.data"
      :headers="headers"
      :table-data="genericFetchEntity.data['interview_forms']"
      :pagination="genericFetchEntity.pagination"
      @fetch-page="fetchPage($event, 'interview_forms_list')"
      @row-click="goto('interview_forms_id_edit', $event.id)"
  >
    <template v-slot="{id, title, template_type, categories, updated_at, interview_question_count}">
      <td>
        <bkt-table-first-column>
          {{ title }}
        </bkt-table-first-column>
      </td>

      <td>
        <div class="d-flex align-items-center">
          <p>
            {{template_type}}
          </p>
        </div>
      </td>

      <td>
        <p>
          {{interview_question_count}}
        </p>
      </td>

      <td>
        <p>
          {{ updated_at | formatDate }}
        </p>
      </td>

      <td>
        <display-tag-in-index :tags="categories"></display-tag-in-index>
      </td>

      <td>
        <div class="d-flex align-items-center">
          <bkt-dots-button>
            <button
                class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover width-100 pl-3 pr-3 p-3"
                @click.stop="openEditTemplateTags(id)"
            >
              Edit template tags
            </button>
            <button
                class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover width-100 pl-3 pr-3 p-3"
                @click.stop="duplicate(id)"
            >
              Duplicate
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
      headers: ['Template title', 'Type', 'Questions', 'Last Update', 'Tags', ''],
      genericFetchEntity: store.state.genericFetchEntity
    }
  },
  created() {
    store.dispatch('genericFetchEntity/fetch',
        {
          pathKey: 'interview_forms_list'
        }
    )
  },
  methods: {
    async duplicate(id) {
      try {
        const res = await axios.get(this.$routes.generate('interview_forms_id_duplicate', {id}))

        window.location.href = res.request.responseURL
      } catch (e) {
        console.log('error', e)
      }
    },
    async deleteCampaign(id) {
      this.$modal.open({
        type: 'delete',
        title: `Are you sure you want to delete this template ?<br/>(This is a permanent action)`,
        textClose: 'No',
        textConfirm: 'Yes, delete',
        textLoading: 'Deleting ...',
        async confirm() {
          store.dispatch('genericFetchEntity/delete', {
            pathKey: 'interview_forms_id',
            id,
            dataKind: 'interview_forms',
            addToPath: '.json'
          }).then(() => {
            this.$modal.close()
          })
        }
      })
    },
    async openEditTemplateTags(id) {
      this.$modal.open({
        type: 'edit-entity-tags',
        title: 'Edit template tags',
        entityId: id,
        fetchTagsFromEntityPath: 'categories_from_template',
        toggleTagFromEntityPath: 'interview_forms_toggle_tag',
        refreshEntityListPath: 'interview_forms_list'
      })
    }
  },
  components: {DisplayTagInIndex, BktTableFirstColumn, IndexTable, BktDotsButton}
}
</script>