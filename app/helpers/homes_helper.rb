module HomesHelper

    def get_current_url_params
        url_params = ""

        if params[:filter] != nil
            url_params = url_params + "&filter="+params[:filter].to_s
        end

        if params[:tag] != nil
            url_params = url_params + "&tag="+params[:tag].to_s
        end

        if params[:user] != nil
            url_params = url_params + "&user="+params[:user].to_s
        end

        return url_params

    end
end
