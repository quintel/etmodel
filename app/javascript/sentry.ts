import * as Sentry from '@sentry/browser';

declare const globals: {
  sentry_dsn?: string;
  sentry_traces?: number;
  release?: string;
  env?: string;
};

const enabledEnvs = ['production', 'staging'];

if (globals && globals.sentry_dsn && enabledEnvs.includes(globals.env)) {
  Sentry.init({
    dsn: globals.sentry_dsn,
    release: globals.release,
    environment: globals.env,
    integrations: [
      Sentry.browserTracingIntegration(),
    ],

    // Percentage of transactions to capture for tracing
    tracesSampleRate: globals.sentry_traces,
  });
}
