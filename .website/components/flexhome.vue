<script lang="ts" setup>
import { Content, useData } from 'vitepress/dist/client/index.js';
import { VPHomeContent } from 'vitepress/theme';
const frontmatter = useData();
</script>

<template>
    <div id="flexhome" class="flex flex-col w-full items-center">
        <VPHomeContent v-if="frontmatter.markdownStyles !== false">
            <Content />
        </VPHomeContent>
        <Content v-else />
    </div>
</template>

<style>
#flexhome > .vp-doc.container {
    margin: 0;
    padding: 0;
}
</style>
