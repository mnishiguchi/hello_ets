defmodule HelloEtsTest do
  use ExUnit.Case
  doctest HelloEts

  # https://github.com/lucaong/cubdb
  test "CubDB" do
    assert :ok == CubDB.put(CubDB, :word, "Hello")
    assert "Hello" == CubDB.get(CubDB, :word)
    assert :ok == CubDB.delete(CubDB, :word)
    assert nil == CubDB.get(CubDB, :word)
  end

  describe "plain Erlang" do
    # https://erlang.org/doc/man/ets.html
    test "ETS" do
      assert :my_ets_table ==
               :ets.new(:my_ets_table, [
                 :named_table,
                 :set,
                 read_concurrency: true,
                 write_concurrency: true
               ])

      info = :ets.info(:my_ets_table)
      assert is_list(info)

      assert true == :ets.insert(:my_ets_table, word: "Hello")
      assert [word: "Hello"] == :ets.lookup(:my_ets_table, :word)
      assert true == :ets.delete(:my_ets_table, :word)
      assert [] == :ets.lookup(:my_ets_table, :word)

      assert true == :ets.delete(:my_ets_table)
      assert :undefined == :ets.info(:my_ets_table)
    end

    # https://erlang.org/doc/man/dets.html
    test "DETS" do
      assert {:ok, :my_dets_table} ==
               :dets.open_file(:my_dets_table,
                 file: 'tmp/my_dets_table',
                 type: :set
               )

      info = :dets.info(:my_dets_table)
      assert is_list(info)

      assert :ok == :dets.insert(:my_dets_table, word: "Hello")
      assert [word: "Hello"] == :dets.lookup(:my_dets_table, :word)
      assert :ok == :dets.delete(:my_dets_table, :word)
      assert [] == :dets.lookup(:my_dets_table, :word)

      assert :ok == :dets.close(:my_dets_table)
      assert :undefined == :dets.info(:my_dets_table)
    end
  end

  describe "custom wrappers that act like CubDB" do
    test "HelloEts.MemoryStore" do
      HelloEts.MemoryStore.create_table()

      assert :ok == HelloEts.MemoryStore.put(:word, "Hello")
      assert "Hello" == HelloEts.MemoryStore.get(:word)
      assert :ok == HelloEts.MemoryStore.delete(:word)
      assert nil == HelloEts.MemoryStore.get(:word)

      assert :ok == HelloEts.MemoryStore.delete_table()
    end

    test "HelloEts.FileStore" do
      HelloEts.FileStore.open(data_dir: "tmp")

      assert :ok == HelloEts.FileStore.put(:word, "Hello")
      assert "Hello" == HelloEts.FileStore.get(:word)
      assert :ok == HelloEts.FileStore.delete(:word)
      assert nil == HelloEts.FileStore.get(:word)

      assert :ok == HelloEts.FileStore.close()
    end
  end

  describe "Stash" do
    test "ETS wrapper" do
      assert true == Stash.set(Stash, :word, "Hello")
      assert "Hello" == Stash.get(Stash, :word)
      assert true == Stash.delete(Stash, :word)
      assert nil == Stash.get(Stash, :word)
    end

    # This feature seems broken...
    # test "persist" do
    #   assert true == Stash.set(Stash, :word, "Hello")
    #   assert "Hello" == Stash.get(Stash, :word)
    #   Stash.persist(Stash, "tmp/persist")
    #   assert true == Stash.delete(Stash, :word)
    #   assert 0 == Stash.size(Stash)
    #   assert {:ok, 'tmp/persist'} == Stash.load(Stash, "tmp/persist")
    #   assert 1 == Stash.size(Stash)
    # end
  end

  test "Elixir ETS" do
    assert %ETS.Set{} =
             ETS.Set.new!(
               name: :my_ets_set_table,
               read_concurrency: true,
               write_concurrency: true
             )

    my_ets_set_table = ETS.Set.wrap_existing!(:my_ets_set_table)

    assert {:ok, info} = ETS.Set.info(my_ets_set_table, true)
    assert is_list(info)

    assert %ETS.Set{} = ETS.Set.put!(my_ets_set_table, {:word, "Hello"})

    assert {:ok, {:word, "Hello"}} = ETS.Set.get(my_ets_set_table, :word)
    assert {:word, "Hello"} = ETS.Set.get!(my_ets_set_table, :word)

    assert {:ok, %ETS.Set{}} = ETS.Set.delete(my_ets_set_table, :word)
    assert %ETS.Set{} = ETS.Set.delete!(my_ets_set_table, :word)

    assert {:ok, nil} = ETS.Set.get(my_ets_set_table, :word)
    assert is_nil(ETS.Set.get!(my_ets_set_table, :word))

    assert %ETS.Set{} = ETS.Set.delete!(my_ets_set_table)
    assert {:error, :table_not_found} == ETS.Set.info(my_ets_set_table, true)
  end
end
