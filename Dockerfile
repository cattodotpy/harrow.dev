FROM oven/bun:alpine as builder

RUN apk add --no-cache git

RUN mkdir -p /app
WORKDIR /app

RUN cd /app && git clone  https://github.com/cattodotpy/harrow.dev

WORKDIR /app/harrow.dev

RUN bun install 
RUN bun run build 

FROM oven/bun:alpine

COPY --from=builder /app/harrow.dev /app/harrow.dev

WORKDIR /app/harrow.dev

CMD ["bun", "./build/index.js"]

