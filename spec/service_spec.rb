# frozen_string_literal: true

require 'spec_helper'

describe 'etcd_service_manager_systemd' do
  platform 'ubuntu', '24.04'
  step_into :etcd_service_manager_systemd

  context 'stopping an instance' do
    recipe do
      etcd_service_manager_systemd 'example' do
        action :stop
      end
    end

    it 'stops the systemd unit' do
      expect(chef_run).to stop_systemd_unit('etcd-example.service')
    end
  end

  context 'restarting an instance' do
    recipe do
      etcd_service_manager_systemd 'example' do
        action :restart
      end
    end

    it 'restarts the existing systemd unit' do
      expect(chef_run).to restart_systemd_unit('etcd-example.service')
    end
  end
  context 'deleting an instance' do
    recipe do
      etcd_service_manager_systemd 'example' do
        config_file '/etc/etcd/example.yml'
        wal_dir '/var/lib/etcd-wal/example'
        action :delete
      end
    end

    it 'removes configuration, data, WAL, logs and the legacy marker' do
      expect(chef_run).to delete_file('/etc/etcd/example.yml')
      expect(chef_run).to delete_directory('/example.etcd')
      expect(chef_run).to delete_directory('/var/lib/etcd-wal/example')
      expect(chef_run).to delete_file('/var/log/etcd-example.log')
      expect(chef_run).to delete_file('/etc/etcd-example-firstconverge')
    end
  end
end
