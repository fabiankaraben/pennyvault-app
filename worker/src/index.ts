export interface Env {
    ASSETS: Fetcher;
}

export default {
    async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
        const response = await env.ASSETS.fetch(request);

        // If the request is for a path that doesn't exist (returns 404),
        // and it's not a file (doesn't have an extension), serve index.html
        // This is useful for SPAs like Flutter web.
        if (response.status === 404) {
            const url = new URL(request.url);
            if (!url.pathname.includes('.')) {
                return env.ASSETS.fetch(new Request(url.origin + '/index.html', request));
            }
        }

        return response;
    },
};
