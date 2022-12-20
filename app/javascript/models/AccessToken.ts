class AccessToken {
  constructor(public readonly token: string, public readonly expiresAt: Date) {}

  /**
   * Refreshes the access token, returning a new token.
   */
  async refresh(): Promise<AccessToken> {
    const resp = await fetch('/refresh/token', { method: 'POST' });

    if (!resp.ok) {
      // get error message from body or default to response status
      return Promise.reject({ error: resp.status });
    }

    const json = await resp.json();
    return new AccessToken(json.access_token, new Date(json.expires_at));
  }

  isExpired(): boolean {
    return this.expiresAt < new Date();
  }
}

export default AccessToken;
