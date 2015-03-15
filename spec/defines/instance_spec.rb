require 'spec_helper'

describe 'btsync::instance' do

  let (:facts) { {
    :ipaddress     => '0.0.0.0',
    :puppet_vardir => '/var/lib/puppet',
  } }

  let :pre_condition do
    "class {'btsync': }"
  end

  let(:title) { 'foo' }
  
  context 'when using no parameters' do
    let(:params) { { } }

    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_concat_build('btsync_foo') }
    it { is_expected.to contain_file('/etc/btsync/foo.conf').with(
      :owner => 'foo',
      :group => nil,
      :mode  => '0400'
    ) }
    it { is_expected.to contain_concat_fragment('btsync_foo+01') }
    it { is_expected.to contain_concat_fragment('btsync_foo+02')\
      .with_content('{') }
    it { is_expected.to contain_concat_build('btsync_foo_json').with(
      :parent_build   => 'btsync_foo',
      :target         => '/var/lib/puppet/concat/fragments/btsync_foo/03',
      :file_delimiter => ',',
      :append_newline => :false
    ) }
    it { is_expected.to contain_concat_fragment('btsync_foo_json+01') }
    it { is_expected.to contain_concat_fragment('btsync_foo_json+02') }
    it { is_expected.to contain_concat_fragment('btsync_foo+99')\
      .with_content('}') }
  end

  context 'when using a wrong conffile' do
    let(:params) { {
      :conffile => 'bar'
    } }
    it 'is_expected.to fail' do
      expect { is_expected.to compile }.to raise_error(/is not an absolute path/)
    end
  end

  context 'when using a wrong storage_path' do
    let(:params) { {
      :storage_path => 'bar'
    } }
    it 'is_expected.to fail' do
      expect { is_expected.to compile }.to raise_error(/is not an absolute path/)
    end
  end

  context 'when specify user' do
    let(:params) { {
      :user => 'bar'
    } }
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_file('/etc/btsync/foo.conf').with(
      :owner => 'bar',
      :group => nil,
      :mode  => '0400'
    ) }
  end

  context 'when specify group' do
    let(:params) { {
      :group => 'bar'
    } }
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_file('/etc/btsync/foo.conf').with(
      :owner => 'foo',
      :group => 'bar',
      :mode  => '0400'
    ) }
  end

  context 'when specify a conffile' do
    let(:params) { {
      :conffile => '/foo/bar/baz'
    } }
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_file('/foo/bar/baz').with(
      :owner => 'foo',
      :group => nil,
      :mode  => '0400'
    ) }
  end

  context 'when specify a shared folder' do
    let(:params) { {
      :shared_folders => {
        'bar'         => { 'dir' => '/bar' },
      }
    } }
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_btsync__shared_folder('bar') }
  end

  context 'when specify multiple shared folders' do
    let(:params) { {
      :shared_folders => {
        'bar'         => { 'dir' => '/bar' },
        'baz'         => { 'dir' => '/baz' },
      }
    } }
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_btsync__shared_folder('bar') }
    it { is_expected.to contain_btsync__shared_folder('baz') }
  end

  context 'when specify a wrong disk_low_priority' do
    let(:params) { {
      :disk_low_priority => 'bar'
    } }
    it 'is_expected.to fail' do
      expect { is_expected.to compile }.to raise_error(/is not a boolean/)
    end
  end

  context 'when specify disk_low_priority' do
    let(:params) { {
      :disk_low_priority => false
    } }
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_concat_fragment('btsync_foo_json+disk_low_priority').with_content(/"disk_low_priority": false/) }
  end

  context 'when specify a wrong folder_rescan_interval' do
    let(:params) { {
      :folder_rescan_interval => 'bar'
    } }
    it 'is_expected.to fail' do
      expect { is_expected.to compile }.to raise_error(/does not match/)
    end
  end

  context 'when specify folder_rescan_interval' do
    let(:params) { {
      :folder_rescan_interval => 5
    } }
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_concat_fragment('btsync_foo_json+folder_rescan_interval').with_content(/"folder_rescan_interval": 5/) }
  end

  context 'when specify a wrong lan_encrypt_data' do
    let(:params) { {
      :lan_encrypt_data => 'bar'
    } }
    it 'is_expected.to fail' do
      expect { is_expected.to compile }.to raise_error(/is not a boolean/)
    end
  end

  context 'when specify lan_encrypt_data' do
    let(:params) { {
      :lan_encrypt_data => true
    } }
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_concat_fragment('btsync_foo_json+lan_encrypt_data').with_content(/"lan_encrypt_data": true/) }
  end

  context 'when specify a wrong lan_use_tcp' do
    let(:params) { {
      :lan_use_tcp => 'bar'
    } }
    it 'is_expected.to fail' do
      expect { is_expected.to compile }.to raise_error(/is not a boolean/)
    end
  end

  context 'when specify lan_use_tcp' do
    let(:params) { {
      :lan_use_tcp => true
    } }
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_concat_fragment('btsync_foo_json+lan_use_tcp').with_content(/"lan_use_tcp": true/) }
  end

  context 'when specify a wrong max_file_size_diff_for_patching' do
    let(:params) { {
      :max_file_size_diff_for_patching => 'bar'
    } }
    it 'is_expected.to fail' do
      expect { is_expected.to compile }.to raise_error(/does not match/)
    end
  end

  context 'when specify max_file_size_diff_for_patching' do
    let(:params) { {
      :max_file_size_diff_for_patching => 5
    } }
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_concat_fragment('btsync_foo_json+max_file_size_diff_for_patching').with_content(/"max_file_size_diff_for_patching": 5/) }
  end

  context 'when specify a wrong max_file_size_for_versioning' do
    let(:params) { {
      :max_file_size_for_versioning => 'bar'
    } }
    it 'is_expected.to fail' do
      expect { is_expected.to compile }.to raise_error(/does not match/)
    end
  end

  context 'when specify max_file_size_for_versioning' do
    let(:params) { {
      :max_file_size_for_versioning => 5
    } }
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_concat_fragment('btsync_foo_json+max_file_size_for_versioning').with_content(/"max_file_size_for_versioning": 5/) }
  end

  context 'when specify a wrong rate_limit_local_peers' do
    let(:params) { {
      :rate_limit_local_peers => 'bar'
    } }
    it 'is_expected.to fail' do
      expect { is_expected.to compile }.to raise_error(/is not a boolean/)
    end
  end

  context 'when specify rate_limit_local_peers' do
    let(:params) { {
      :rate_limit_local_peers => true
    } }
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_concat_fragment('btsync_foo_json+rate_limit_local_peers').with_content(/"rate_limit_local_peers": true/) }
  end

  context 'when specify a wrong sync_max_time_diff' do
    let(:params) { {
      :sync_max_time_diff => 'bar'
    } }
    it 'is_expected.to fail' do
      expect { is_expected.to compile }.to raise_error(/does not match/)
    end
  end

  context 'when specify sync_max_time_diff' do
    let(:params) { {
      :sync_max_time_diff => 5
    } }
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_concat_fragment('btsync_foo_json+sync_max_time_diff').with_content(/"sync_max_time_diff": 5/) }
  end

  context 'when specify a wrong sync_trash_ttl' do
    let(:params) { {
      :sync_trash_ttl => 'bar'
    } }
    it 'is_expected.to fail' do
      expect { is_expected.to compile }.to raise_error(/does not match/)
    end
  end

  context 'when specify sync_trash_ttl' do
    let(:params) { {
      :sync_trash_ttl => 5
    } }
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_concat_fragment('btsync_foo_json+sync_trash_ttl').with_content(/"sync_trash_ttl": 5/) }
  end

end
