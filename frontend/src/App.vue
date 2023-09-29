<template>
  <NewTask @btn-new-task="handleNewTask" />
  <TasksList v-if="showTasksList" @edit-task-id="handleNewTask" />
  <TaskForm
    v-else
    @task-created="handleCreateTask"
    @task-updated="handleUpdateTask"
    :currentTask="currentTask"
  />
</template>

<script>
import NewTask from "./components/NewTask.vue";
import TasksList from "./components/TasksList.vue";
import TaskForm from "./components/TaskForm.vue";

export default {
  name: "App",
  data() {
    return {
      showTasksList: true,
      currentTask: 0,
    };
  },
  components: {
    NewTask,
    TasksList,
    TaskForm,
  },
  methods: {
    handleNewTask(taskId) {
      this.currentTask = taskId || 0;
      this.showTasksList = !this.showTasksList;
    },

    async handleCreateTask(form) {
      await fetch(`http://localhost:4567/api/v1/tasks`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(form),
      })
        .then((response) => {
          if (response.ok) {
            return response.json();
          } else {
            throw new Error("Failed to create task");
          }
        })
        .then((data) => {
          console.log("Task created successfully:", data);
        })
        .then(() => {
          this.handleNewTask();
        })
        .catch((error) => {
          console.error("Error creating task:", error);
        });
    },

    async handleUpdateTask(form, taskId) {
      try {
        const response = await fetch(
          `http://localhost:4567/api/v1/tasks/${taskId}`,
          {
            method: "PUT",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify(form),
          }
        );

        if (response.ok) {
          console.log("Task updated successfully");
          this.handleNewTask();
        } else {
          console.error("Failed to update task");
        }
      } catch (error) {
        console.error("Error updating task:", error);
      }
    },
  },
};
</script>

<style>
@import url("~simpledotcss/simple.min.css");
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  margin-top: 60px;
}
</style>
