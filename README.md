# skill_watch

**One capability bit from GBT V8, packaged standalone.** No. 278 of 341,
`system` domain (System).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> **技能观察器**（主人令 2026-10-11「使用技能在每次使用的时候都要注意技能的**变化和短板**来打磨进化」）：每次用技能留三笔 —— **用成没成（读数）· 它变了没（面漂移）· 它短板在哪（打磨点）**。① observe：cap/成败/耗时/错误类/被门拦 ⇒ 只追加落账；② snapshot+drift：把技能当下可控制面（op 表/参数/节点/版本）与上次快照比，变了报 surface_changed（对齐「节点消失=断连」，升级改名也算）；③ shortboards+advise：按读数排行短板（失败率/耗时 P90/缺依赖/被门拒），每条给**可执行的打磨点**。铁律：只追加 · 不许编（无观测就报无观测）· **每条建议必须挂它对应的读数**。op=observe/snapshot/shortboards/advise/drift

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-skill-watch.git
cd gbt-skill-watch
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_skill_watch info                  # capability card
python -m gbt_skill_watch spec --json           # machine-readable contract
python -m gbt_skill_watch check --payload '{}'
python -m gbt_skill_watch run   --payload '{}'
```

Real `info` output from this machine:

```text
skill_watch  (system)  v1.0.0
----------------------------------------
**技能观察器**（主人令 2026-10-11「使用技能在每次使用的时候都要注意技能的**变化和短板**来打磨进化」）：每次用技能留三笔 —— **用成没成（读数）· 它变了没（面漂移）· 它短板在哪（打磨点）**。① observe：cap/成败/耗时/错误类/被门拦 ⇒ 只追加落账；② snapshot+drift：把技能当下可控制面（op 表/参数/节点/版本）与上次快照比，变了报 surface_changed（对齐「节点消失=断连」，升级改名也算）；③ shortboards+advise：按读数排行短板（失败率/耗时 P90/缺依赖/被门拒），每条给**可执行的打磨点**。铁律：只追加 · 不许编（无观测就报无观测）· **每条建议必须挂它对应的读数**。op=observe/snapshot/shortboards/advise/drift

gated      : False
external   : False
multi-op   : True
params     : (none)
values     : observe, snapshot, shortboards, advise, drift
```

Wire a real implementation:

```python
from gbt_skill_watch import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（5 个）**：`observe`、`snapshot`、`shortboards`、`advise`、`drift`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Not gated: the registry marks this bit `safe: true`.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.13s
```

## Provenance

| field | value |
|---|---|
| capability | `skill_watch` |
| domain | `system` |
| handler | `skill_watch` |
| safe | `True` (gated = `False`) |
| external | `False` |
| atlas page | [system/skill_watch](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/system/skill_watch.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
