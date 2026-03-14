import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ArchivesList } from './archives-list';

describe('ArchivesList', () => {
  let component: ArchivesList;
  let fixture: ComponentFixture<ArchivesList>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ArchivesList]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ArchivesList);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
