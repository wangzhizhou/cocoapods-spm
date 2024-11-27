require "cocoapods-spm/hooks/base"
require "cocoapods-spm/resolver"

module Pod
  module SPM
    class Hook
      class AddSpmPkgs < Hook
        def run
          return if @spm_resolver.result.spm_pkgs.empty?

          if podfile.installation_options.generate_multiple_pod_projects
            add_spm_pkg_refs_to_pod_target_subprojects
          else
            add_spm_pkg_refs_to_project
            add_spm_products_to_targets
            pods_project.save
          end
        end

        private

        def add_spm_pkg_refs_to_pod_target_subprojects
          pod_target_subprojects.each do |pod_target_subproject|
            pod_target_subproject.root_object.targets.each do |target|
              @spm_resolver.result.spm_dependencies_for(target).each do |dep|
                pkg_ref = dep.pkg.create_pkg_ref(pod_target_subproject)
                pod_target_subproject.root_object.package_references << pkg_ref
                target_dep_ref = pkg_ref.create_target_dependency_ref(dep.product)
                target.dependencies << target_dep_ref
                target.package_product_dependencies << target_dep_ref.product_ref if dep.pkg.use_default_xcode_linking?
              end
            end
            pod_target_subproject.save
          end
        end

        def spm_pkg_refs
          @spm_pkg_refs ||= {}
        end

        def add_spm_pkg_refs_to_project
          @spm_pkg_refs = @spm_resolver.result.spm_pkgs.to_h do |pkg|
            pkg_ref = pkg.create_pkg_ref(pods_project)
            pods_project.root_object.package_references << pkg_ref
            [pkg.name, pkg_ref]
          end
        end

        def spm_pkgs_by_target
          @spm_pkgs_by_target ||= {}
        end

        def add_spm_products_to_targets
          pods_project.targets.each do |target|
            @spm_resolver.result.spm_dependencies_for(target).each do |dep|
              pkg_ref = spm_pkg_refs[dep.pkg.name]
              target_dep_ref = pkg_ref.create_target_dependency_ref(dep.product)
              target.dependencies << target_dep_ref
              target.package_product_dependencies << target_dep_ref.product_ref if dep.pkg.use_default_xcode_linking?
            end
          end
        end
      end
    end
  end
end
