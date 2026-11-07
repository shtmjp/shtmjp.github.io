# Keep Ruby aligned with .github/workflows/jekyll.yml.
FROM ruby:3.3-bookworm

RUN apt-get update && apt-get install -y --no-install-recommends nodejs npm \
    && npm install --global uglify-js@3.19.3 \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -g 1000 vscode \
    && useradd -m -u 1000 -g vscode vscode

WORKDIR /usr/src/app
RUN chown vscode:vscode /usr/src/app
USER vscode

COPY --chown=vscode:vscode Gemfile ./
RUN bundle install

EXPOSE 4000

# Build the ignored JavaScript bundle before serving the mounted checkout.
CMD ["sh", "-c", "npm run build:js && exec bundle exec jekyll serve --host 0.0.0.0 --force_polling --config _config.yml,_config_docker.yml"]
