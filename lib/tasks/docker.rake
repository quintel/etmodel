# frozen_string_literal: true

# rubocop:disable Rails/RakeEnvironment

namespace :docker do
  task :build do
    sh 'docker build . -t etmodel:latest'
  end

  desc 'Builds and publishes the image to Docker Hub'
  task release: [:build] do
    sh 'docker tag etmodel:latest quintel/etmodel:latest'
    sh 'docker push quintel/etmodel:latest'
  end
end

# rubocop:enable Rails/RakeEnvironment
