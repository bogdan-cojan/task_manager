<template>
  <div class="container">
    <p style="font-size: 25px">Tasks</p>
    <button @click="handleNewTask" class="button" style="height: fit-content">
      New task
    </button>
  </div>
</template>

<script>
export default {
  methods: {
    handleNewTask() {
      this.$emit("btn-new-task");
    },
  },
};
</script>

<style scoped>
.container {
  border-bottom: 4px solid;
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 90px;
}
</style>
