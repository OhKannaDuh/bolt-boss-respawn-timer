<script setup lang="ts">
import BoltBrowser from "koala/BoltBrowser";

const props = defineProps<{
  plugin: BoltBrowser;
}>();

import { computed, ref, type Ref } from "vue";

const tps = 60;

type Times = {
  standard: number;
  fast: number;
  fastest: number;
}

const times: Times = { // Respawn time in milliseconds
  standard: 72000,
  fast: 50000,
  fastest: 27000,
}

const mode: Ref<keyof Times> = ref('fastest')

const interval = ref<undefined | number>(undefined);
const lastFrameTime = ref(new Date(0));
const stopped = ref(true);
const timeElapsed = ref(new Date(0));

const tick = () => {
  const currentTime = new Date();
  if (stopped.value) {
    lastFrameTime.value = currentTime;
    return;
  }

  const delta = new Date(currentTime.getTime() - lastFrameTime.value.getTime());
  lastFrameTime.value = currentTime;

  // If more than an hour has elapsed
  timeElapsed.value = new Date(timeElapsed.value.getTime() - delta.getTime());
  if (timeElapsed.value.getTime() <= 0) {
    timeElapsed.value = new Date(0)
    stop()
  }
};

const start = () => {
  stopped.value = false;
  lastFrameTime.value = new Date();
  timeElapsed.value = new Date(times[mode.value])
  interval.value = window.setInterval(tick, 1000 / tps);
};

const stop = () => {
  stopped.value = true;
  window.clearInterval(interval.value);
  interval.value = undefined;
};

const toggle = () => {
  stopped.value ? start() : stop();
};

const reset = () => {
  timeElapsed.value = new Date(0);
  stop();
};

const displayTime = computed(() => {
  let components = [];

  // If more than an hour has elapsed
  if (timeElapsed.value.getTime() >= 3600000) {
    components.push(
      timeElapsed.value.getUTCHours().toString().padStart(2, "0")
    );
  }

  components = components.concat([
    timeElapsed.value.getUTCMinutes().toString().padStart(2, "0"),
    timeElapsed.value.getUTCSeconds().toString().padStart(2, "0"),
  ]);

  return components.join(":");
});

const set_mode = (key: keyof Times) => {
  mode.value = key
  props.plugin.message('mode', {mode: key})
}

props.plugin.onmessage('start', (_) => {
  start()
});

props.plugin.onmessage('config', (data) => {
  mode.value = data.respawn_speed ?? 'fastest'
});
</script>

<template>
  <div class="content">
    <div class="timer">
      {{ displayTime }}
    </div>
    <div class="controls">
      <button class="button" :class="{active: mode === 'standard'}" @click="set_mode('standard')">Standard</button>
      <button class="button" :class="{active: mode === 'fast'}" @click="set_mode('fast')">Fast</button>
      <button class="button" :class="{active: mode === 'fastest'}" @click="set_mode('fastest')">Fastest</button>

    </div>
  </div>
</template>

<style scoped>
@import "rune-ui/content.css";
@import "rune-ui/button.css";

.content {
  /* padding-top: 8px; */
  flex-grow: 1;
  display: flex;
  flex-direction: column;
}

.timer {
  /* padding: 0 12px 12px; */
  text-align: center;
  flex-grow: 1;
}

.controls {
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.button {
  flex-grow: 1;
  margin: 2px;
  color: #aed0e0;
}
</style>
