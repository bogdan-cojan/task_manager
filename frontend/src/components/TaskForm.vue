<template>
  <div class="container notice">
    <label for="taskTitle">Title</label>
    <input v-model="form.title" type="text" id="taskTitle" /><br />

    <label for="taskDescription">Description</label>
    <textarea
      v-model="form.description"
      id="taskDescription"
      rows="4"
    ></textarea
    ><br />

    <button @click="handleSaveTask" class="button">Save</button>
  </div>
</template>

<script>
export default {
  props: ["currentTask"],
  data() {
    return {
      form: {
        title: "",
        description: "",
      },
    };
  },
  mounted() {
    this.fetchTask();
  },
  methods: {
    async fetchTask() {
      if (this.currentTask != 0) {
        try {
          const response = await fetch(
            `http://localhost:4567/api/v1/tasks/${this.currentTask}`,
            {
              method: "GET",
            }
          );

          if (response.ok) {
            const data = await response.json();
            this.form.title = data["title"];
            this.form.description = data["description"];
          } else {
            console.error("Failed to fetch tasks");
          }
        } catch (error) {
          console.error("Error fetching tasks:", error);
        }
      }
    },

    handleSaveTask() {
      if (this.currentTask == 0) {
        this.$emit("task-created", this.form);
      } else {
        this.$emit("task-updated", this.form, this.currentTask);
      }
      this.form.title = "";
      this.form.description = "";
    },
  },
};
</script>

<style scoped>
.container {
  display: flex;
  flex-direction: column;
  align-items: center;
}
</style>
