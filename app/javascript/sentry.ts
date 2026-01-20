import * as Sentry from '@sentry/browser';

declare const globals: {
  sentry_dsn?: string;
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

    // Capture 10% of transactions for tracing
    tracesSampleRate: 0.1,

    // Propagate traces to ETEngine and MyETM for end-to-end profiling
    tracePropagationTargets: [
      /^https:\/\/.*\.energytransitionmodel\.com/,
      'localhost',
    ],

    // Profile 100% of sampled transactions
    profileSessionSampleRate: 1.0,

    // Automatically start/stop profiler based on tracing spans
    profileLifecycle: 'trace',
  });
}
