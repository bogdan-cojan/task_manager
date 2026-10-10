<template>
  <div>
    <div v-if="errorMessage" class="error-banner" role="alert">
      {{ errorMessage }}
    </div>
    <NewTask @btn-new-task="handleNewTask" />
    <TasksList v-if="showTasksList" @edit-task-id="handleNewTask" />
    <TaskForm
      v-else
      @task-created="handleCreateTask"
      @task-updated="handleUpdateTask"
      :currentTask="currentTask"
    />
  </div>
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
      errorMessage: "",
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
      this.errorMessage = "";
      this.showTasksList = !this.showTasksList;
    },

    async handleCreateTask(form) {
      try {
        const response = await fetch(`http://localhost:4567/api/v1/tasks`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify(form),
        });

        if (!response.ok) {
          const errorData = await response.json().catch(() => null);
          throw new Error(errorData?.details?.join(" ") || errorData?.error || "Failed to create task");
        }

        const data = await response.json();
        console.log("Task created successfully:", data);
        this.errorMessage = "";
        this.handleNewTask();
      } catch (error) {
        console.error("Error creating task:", error);
        this.errorMessage = error.message;
      }
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

        if (!response.ok) {
          const errorData = await response.json().catch(() => null);
          throw new Error(errorData?.details?.join(" ") || errorData?.error || "Failed to update task");
        }

        console.log("Task updated successfully");
        this.errorMessage = "";
        this.handleNewTask();
      } catch (error) {
        console.error("Error updating task:", error);
        this.errorMessage = error.message;
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

.error-banner {
  max-width: 600px;
  margin: 0 auto 1rem;
  padding: 0.75rem 1rem;
  border: 1px solid #d33;
  background: #ffe6e6;
  color: #a00;
  border-radius: 6px;
}
</style>
