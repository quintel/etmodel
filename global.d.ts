import _I18n from 'i18n-js';

declare global {
  const I18n: typeof _I18n;

  const App: {
    settings: {
      get: (key: string) => unknown;
      set: (key: string, value: string | number | undefined) => unknown;
      on: (eventName: string, event: (...args: unknown[]) => unknown) => unknown;
      off: (eventName: string, event: (...args: unknown[]) => unknown) => unknown;
    };
  };
}
