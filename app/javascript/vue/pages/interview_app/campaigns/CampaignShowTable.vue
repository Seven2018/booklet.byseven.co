
<template>
  <index-table
      :headers="headers"
      :table-data="set_interviews"
      :pagination="null"
      @fetch-page=""
      @row-click=""
      class="cursor-pointer"
  >
    <template v-slot="set_interview">
      <td>
        Interviewee
      </td>

      <td>
        template
      </td>

      <td>
        Interviewer
      </td>

      <td>
        tags
<!--        <display-tag-in-index :tags="categories"></display-tag-in-index>-->
      </td>

      <td>
        completion
      </td>

      <td>
        <div class="d-flex align-items-center">
          <bkt-dots-button>
            <button
                class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover width-100 pl-3 pr-3 p-3"
                @click.stop=""
            >
              Edit campaign tags
            </button>
            <button
                class="flex-row-start-centered fs-1_4rem bkt-red bkt-bg-light-grey10-hover width-100 pl-3 pr-3 p-3"
                @click.stop=""
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
import IndexTable from "../../../components/IndexTable";
import BktDotsButton from "../../../components/BktDotsButton";

export default {
  components: {IndexTable, BktDotsButton},
  props: ['set_interviews'],
  data() {
    return {
      headers: ['Interviewee', 'Template', 'Interviewer', 'Tags', 'Completion', ''],
    }
  }
}
</script>