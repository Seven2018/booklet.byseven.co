<template>
  <index-table
      v-if="genericFetchEntity.data"
      :headers="headers"
      :tableData="genericFetchEntity.data.users"
      :pagination="genericFetchEntity.pagination"
      @fetch-page="fetchPage"
  >
    <template v-slot="{id, firstname, lastname, picture, job_title, access_level_int, manager, objectives_count}">
      <td>
        <user-info-in-table :user="{picture, firstname, lastname, job_title}"></user-info-in-table>
      </td>

      <td>
        <div class="align-items-center">
          <div class="flex-column ">
            <p>
              {{ access_level_int | convert_hr | capitalize }}
            </p>
            <a
                v-if="access_level_int !== 'employee'"
                :href="$routes.generate('objective_user_my_team_objectives', {id})"
                class="bkt-objective-blue"
                style="text-decoration: underline">View Team Roadmap</a>
          </div>
        </div>
      </td>

      <td>
        <div v-if="manager" class="d-flex align-items-center">
          <div class="flex-column ">
            <img class="rounded-circle width-3rem height-3rem"
                 :src="manager.picture"
                 onerror="this.onerror=null;this.src='//i0.wp.com/rouelibrenmaine.fr/wp-content/uploads/2018/10/empty-avatar.png'"
                 alt="">
          </div>

          <div class="flex-column ml-3 width-25rem">
            <div class="flex-row-start-centered">
              <p class="font-weight-500 text-truncate">{{ `${manager.firstname} ${manager.lastname}` }}</p>
            </div>
          </div>
        </div>
      </td>


      <td>
        <p>
          {{ objectives_count }}
        </p>
      </td>

      <td>
        <div class="flex-row-between-centered align-items-center">
          <div class="flex-column ">
            <a
                v-if="manager"
                :href="$routes.generate('objective_user_my_team_objectives', {id: manager.id})"
                class="bkt-objective-blue"
                style="text-decoration: underline">View Team Roadmap of his/her manager</a>
          </div>

          <div class="flex-column">
            <bkt-button type="blue" :href="$routes.generate('objective_user_show', {id})">
              View Targets
            </bkt-button>
          </div>
        </div>
      </td>
    </template>
  </index-table>
</template>

<script>
import IndexTable from "../../../components/IndexTable";
import BktButton from "../../../components/BktButton";
import store from "../../../store";
import UserInfoInTable from "../../../components/UserInfoInTable";

export default {
  data() {
    return {
      headers: ['Name', 'Access Level', 'Manager', 'Targets', ''],
      genericFetchEntity: store.state.genericFetchEntity
    }
  },
  created() {
    store.dispatch('genericFetchEntity/fetch',
        {
          pathKey: 'objective_list'
        }
)
  },
  methods: {
    fetchPage(page) {
      store.dispatch('genericFetchEntity/fetch', {
        pathKey: 'objective_list',
        params: {
          'page[number]': page,
        }
      })
    }
  },
  components: {
    UserInfoInTable,
    IndexTable,
    BktButton
  }
}
</script>
