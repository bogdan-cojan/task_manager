<template>
  <div
    class="container notice"
    v-for="task in this.tasks"
    :key="task.id"
    @click="handleShowDescription(task.id)"
  >
    <div class="txt-group">
      <h1 style="font-size: 25px" v-text="task.title"></h1>
      <p
        v-if="showTaskDescription && currentTask == task.id"
        style="font-size: 20px"
      >
        {{ task.description }}
      </p>
    </div>
    <div class="btn-group">
      <button class="button" @click.stop="handleDeleteTask(task.id)">
        Delete
      </button>
      <button class="button" @click.stop="handleEditTask(task.id)">Edit</button>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      tasks: [],
      showTaskDescription: false,
      currentTask: 0,
    };
  },
  mounted() {
    this.fetchTasks();
  },
  methods: {
    async fetchTasks() {
      try {
        const response = await fetch("http://localhost:4567/api/v1/tasks", {
          method: "GET",
        });

        if (response.ok) {
          const data = await response.json();
          this.tasks = data;
        } else {
          console.error("Failed to fetch tasks");
        }
      } catch (error) {
        console.error("Error fetching tasks:", error);
      }
    },

    async handleDeleteTask(taskId) {
      try {
        const response = await fetch(
          `http://localhost:4567/api/v1/tasks/${taskId}`,
          {
            method: "DELETE",
          }
        );

        if (response.ok) {
          await this.fetchTasks();
          console.log("Task deleted successfully");
        } else {
          console.error("Failed to delete task");
        }
      } catch (error) {
        console.error("Error deleting task:", error);
      }
    },

    handleShowDescription(taskId) {
      this.currentTask = taskId;
      this.showTaskDescription = !this.showTaskDescription;
    },

    handleEditTask(taskId) {
      this.$emit("edit-task-id", taskId);
    },
  },
};
</script>

<style scoped>
.container {
  display: flex;
  justify-content: space-between;
  align-items: start;
  padding: 13px;
  padding-top: 5px;
  padding-bottom: 5px;
}
.btn-group {
  width: 25%;
  display: flex;
  justify-content: space-evenly;
}
.txt-group {
  max-width: 75%;
  display: flex;
  flex-direction: column;
}
</style>
