<script setup lang="ts">
import Toolbar from "./components/Toolbar.vue";
import Content from "./components/Content.vue";

import BoltBrowser from "koala/BoltBrowser";

const plugin = new BoltBrowser();

window.addEventListener("DOMContentLoaded", () => {
  plugin.message("ready");
});
</script>

<template>
  <Toolbar :plugin="plugin" />
  <Content :plugin="plugin"/>
</template>

<style scoped></style>
