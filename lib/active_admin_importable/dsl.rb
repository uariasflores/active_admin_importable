module ActiveAdminImportable
  module DSL
    def active_admin_importable(&block)
      action_item :only => :index do
        resource_name = active_admin_config.resource_name.to_s.underscore
        
        label = I18n.t(resource_name, scope: 'active_admin.import', default: "Import #{resource_name.pluralize.humanize}")
        
        link_to label, :action => 'upload_csv'
      end

      collection_action :upload_csv do
        render "admin/csv/upload_csv"
      end

      collection_action :import_csv, :method => :post do
        CsvDb.convert_save(active_admin_config.resource_class, params[:dump][:file], &block)
        redirect_to :action => :index, :notice => "#{active_admin_config.resource_name.to_s} imported successfully!"
      end
    end
  end
end
