import * as Sentry from '@sentry/browser';

declare const globals: {
  sentry_dsn?: string;
  sentry_traces?: number;
  sentry_profiles?: number;
  version?: string;
  env?: string;
};

const enabledEnvs = ['production', 'staging'];

if (globals && globals.sentry_dsn && enabledEnvs.includes(globals.env)) {
  Sentry.init({
    dsn: globals.sentry_dsn,
    release: globals.version,
    environment: globals.env,
    integrations: [
      Sentry.browserTracingIntegration(),
      Sentry.browserProfilingIntegration(),
    ],

    // Percentage of transactions to capture for tracing
    tracesSampleRate: globals.sentry_traces,

    // Percentage of sampled transactions to profile
    profileSessionSampleRate: globals.sentry_profiles,

    // Automatically start/stop profiler based on tracing spans
    profileLifecycle: 'trace',
  });
}
