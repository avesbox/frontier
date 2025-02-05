<script setup>
</script>

<template>
	<div id="hero" class="flex w-full h-[40rem] gap-8 flex items-center justify-center p-8 md:p-0">
		<div class="flex flex-col items-center">
			<div class="p-1 w-48 h-48 flex items-center justify-center">
				<img src="/logo.png">
			</div>
            <div class="text-4xl lg:text-6xl text-center font-bold text-pretty md:w-[44rem]">Simple authentication for Dart & Flutter</div>
            <div class="my-4 lg:my-8 text-xl text-center md:w-[44rem] text-pretty">
				Frontier is a simple strategy-based authentication library for Dart & Flutter. Extremely easy to use and highly customizable to fit your needs.
			</div>
            <div class="flex gap-2">
				<a href="/docs/" class="brand-btn max-w-fit px-8 py-4 rounded-full flex items-center gap-4">Get Started</a>
				<a href="/strategies/" class="max-w-fit px-8 py-4 rounded-full flex items-center gap-4" style="color: var(--vp-c-brand-1-dark)">Strategies</a>
			</div>
        </div>
  	</div>
</template>

<style scoped>
.vp-doc a {
	color: white;
	text-decoration: none;
}

.vp-doc a.brand-btn {
	background-color: var(--vp-c-brand-1-dark);
}

.vp-doc a.text-black {
	color: rgb(27, 27, 31);
}

p {
	margin: 0 !important;
}

ol {
	padding: 0;
}
</style>