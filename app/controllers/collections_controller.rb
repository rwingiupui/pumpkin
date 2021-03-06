class CollectionsController < ApplicationController
  include CurationConcerns::CollectionsControllerBehavior
  skip_load_and_authorize_resource only: :index_manifest
  skip_action_callback :authenticate_user!, only: %i[index_manifest manifest]
  self.presenter_class = WorkSearchBuilder

  def form_class
    CollectionEditForm
  end

  def presenter_class
    CollectionShowPresenter
  end

  def manifest
    respond_to do |f|
      f.json do
        render json: manifest_builder
      end
    end
  end

  def index_manifest
    respond_to do |f|
      f.json do
        render json: all_manifests_builder
      end
    end
  end

  private

    def manifest_builder
      PolymorphicManifestBuilder.new(presenter, ssl: request.ssl?)
    end

    def all_manifests_builder
      AllCollectionsManifestBuilder.new(nil,
                                        ability: current_ability,
                                        ssl: request.ssl?)
    end
end
