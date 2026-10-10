<template>
  <div class="container notice">
    <div v-if="errorMessage" class="error-message" role="alert">
      {{ errorMessage }}
    </div>

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
      errorMessage: "",
    };
  },
  mounted() {
    this.fetchTask();
  },
  methods: {
    validateForm() {
      const title = this.form.title.trim();
      const description = this.form.description.trim();

      if (!title) {
        this.errorMessage = "Title is required.";
        return false;
      }

      if (title.length > 255) {
        this.errorMessage = "Title must be 255 characters or fewer.";
        return false;
      }

      if (!description) {
        this.errorMessage = "Description is required.";
        return false;
      }

      if (description.length > 1000) {
        this.errorMessage = "Description must be 1000 characters or fewer.";
        return false;
      }

      this.errorMessage = "";
      return true;
    },

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
            const errorData = await response.json().catch(() => null);
            console.error(
              "Failed to fetch task:",
              errorData?.error || "Unknown error"
            );
          }
        } catch (error) {
          console.error("Error fetching task:", error);
        }
      }
    },

    handleSaveTask() {
      if (!this.validateForm()) {
        return;
      }

      const payload = {
        title: this.form.title.trim(),
        description: this.form.description.trim(),
      };

      if (this.currentTask == 0) {
        this.$emit("task-created", payload);
      } else {
        this.$emit("task-updated", payload, this.currentTask);
      }

      this.errorMessage = "";
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

.error-message {
  width: 100%;
  margin-bottom: 1rem;
  padding: 0.75rem;
  border: 1px solid #d33;
  background: #ffe6e6;
  color: #a00;
  border-radius: 6px;
  text-align: center;
}
</style>
