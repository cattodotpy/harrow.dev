<script lang="ts">
	import { onDestroy } from 'svelte';

	let currentDate = $state(new Date());
	let nextYear = $derived(new Date(currentDate.getFullYear() + 1, 0, 1));
	let timeLeft: number = $state(0);
	let dateString: string[][] = $state([]);
	let old = $state([] as string[][]);
	let text = ['Days', 'Hours', 'Minutes', 'Seconds'];
	let changed = $state([] as boolean[][]);
	let days;
	let hours;
	let minutes;
	let seconds;

	function updateTime() {
		{
			currentDate = new Date();
			timeLeft = nextYear.getTime() - currentDate.getTime();

			days = Math.floor(timeLeft / (1000 * 60 * 60 * 24));
			hours = Math.floor((timeLeft % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
			minutes = Math.floor((timeLeft % (1000 * 60 * 60)) / (1000 * 60));
			seconds = Math.floor((timeLeft % (1000 * 60)) / 1000);

			// for each digit in the countdown, add a string to the array
			old = dateString;
			dateString = [
				days.toString().padStart(2, '0').split(''),
				hours.toString().padStart(2, '0').split(''),
				minutes.toString().padStart(2, '0').split(''),
				seconds.toString().padStart(2, '0').split('')
			];

			// add the class animate when the digit changes
			changed = dateString.map((arr, i) => {
				return arr.map((digit, j) => {
					return old[i][j] !== digit;
				});
			});

			if (timeLeft < 0) {
				clearInterval(interval);
			}
		}
	}

	let interval = setInterval(updateTime, 500);

	onDestroy(() => {
		clearInterval(interval);
	});
</script>

<main
	class="flex h-screen w-screen flex-col items-center justify-center bg-gradient-to-r from-gray-800 via-gray-900 to-black p-10 text-center text-3xl text-white"
>
	<h1 class="mb-10 text-[2vw] font-bold drop-shadow-lg">
		{currentDate.getFullYear()} still have...
	</h1>

	<div class="countdown-container">
		<div class="flip-clock">
			{#each dateString as digits, i}
				<div class="flip-clock-column">
					<p class="text-2xl font-bold drop-shadow-lg">{text[i]}</p>
					<div class="flex flex-row gap-2">
						{#each digits as digit, j}
							<div class="flip-clock-item" id="{i}-{j}">
								<div class="top {changed[i][j] ? 'animate bg-slate-700' : 'bg-slate-500'}"></div>
								<div class="text">{digit}</div>
								<div class="bottom bg-slate-500"></div>
							</div>
						{/each}
					</div>
				</div>
			{/each}
		</div>
	</div>

	<div class="mt-10 flex w-full flex-col gap-2 text-4xl font-bold drop-shadow-lg">
		{#if timeLeft > 0}
			<!-- percentage -->
			This year is {(100 - (timeLeft / (1000 * 60 * 60 * 24 * 365)) * 100).toFixed(2)}% complete

			<!-- progress bar -->
			<div class="relative mt-2 h-4 w-full rounded-lg border-2">
				<div
					class="absolute left-0 top-0 h-full rounded-lg bg-slate-300"
					style="width: {(100 - (timeLeft / (1000 * 60 * 60 * 24 * 365)) * 100).toFixed(2)}%"
				></div>
			</div>
		{/if}
	</div>

	{#if timeLeft < 0}
		<p class="mt-10 text-4xl font-bold drop-shadow-lg">Happy New Year!</p>
	{/if}
</main>

<style>
	.countdown-container {
		display: flex;
		justify-content: center;
		align-items: center;
		padding: 1.5rem;
	}

	.flip-clock {
		display: flex;
		flex-direction: row;
		gap: 5rem;
	}

	.flip-clock-item {
		position: relative;
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 0.5rem;
		padding: 0.3rem;
		font-weight: bold;
		font-size: 8vw;
		width: 8vw;
		height: 16vw;
	}

	.flip-clock-column {
		display: flex;
		flex-direction: column;
		align-items: center;
	}

	.flip-clock-item .bottom,
	.flip-clock-item .top {
		position: absolute;
		border-radius: 4px;
		width: 100%;
		height: 50%;
		justify-content: center;
		align-items: center;
	}

	.flip-clock-item .top,
	.flip-clock-item .bottom {
		z-index: 2;
	}

	.flip-clock-item .bottom {
		top: 53%;
	}

	.flip-clock-item .text {
		display: flex;
		justify-content: center;
		align-items: center;
		width: 100%;
		height: 100%;
		position: absolute;
		top: 0;
		left: 0;
		z-index: 3;
	}

	.animate {
		transform: rotateX(-180deg);
		transition: transform 0.75s ease;
		transform-style: preserve-3d;
	}
</style>
